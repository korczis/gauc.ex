#![feature(link_args)]
#![feature(plugin)]
#![plugin(rustler_codegen)]
#[cfg(target_os="macos")]
#[link_args = "-flat_namespace -undefined suppress"]
extern {}

extern crate byteorder;

extern crate gauc;

#[macro_use]
extern crate rustler;

#[macro_use]
extern crate lazy_static;

extern crate uuid;

use byteorder::{BigEndian, ReadBytesExt};

use rustler::{NifEnv, NifTerm, NifEncoder, NifResult};

use std::collections::HashMap;

use uuid::Uuid;

use std::sync::Mutex;

lazy_static! {
    static ref CLIENTS: Mutex<HashMap<(u32, u32), gauc::client::Client>> = {
        Mutex::new(HashMap::new())
    };
}

// static mut CLIENTS: Option<HashMap<(u32, u32), gauc::client::Client>> = None;

mod atoms {
    rustler_atoms! {
        atom ok;
        atom error;
        atom invalid_handle;
        //atom __true__ = "true";
        //atom __false__ = "false";
    }
}

rustler_export_nifs! {
    "Elixir.Gauc.Native",
    [
      ("connect", 1, connect),
      ("disconnect", 1, disconnect),
      ("clients", 0, clients),
      ("add", 5, add),
      ("append", 5, append),
      ("get", 2, get),
      ("prepend", 5, prepend),
      ("replace", 5, replace),
      ("set", 5, set),
      ("upsert", 5, upsert)
    ],
    Some(on_load)
}

fn on_load(_env: NifEnv, _load_info: NifTerm) -> bool {
    // resource_struct_init!(gauc::client::Client, env);

    true
}

fn connect<'a>(env: NifEnv<'a>, args: &[NifTerm<'a>]) -> NifResult<NifTerm<'a>> {
    let connection_string: String = args[0].decode()?;

    match gauc::client::Client::connect(&connection_string[..]) {
        Ok(c) => {
            let uuid = Uuid::new_v4();
            let bytes = uuid.as_bytes();
            let low: u32 = (&bytes[0..4]).read_u32::<BigEndian>().unwrap();
            let high: u32 = (&bytes[4..8]).read_u32::<BigEndian>().unwrap();

            let handle = (low, high);
            CLIENTS.lock().unwrap().insert(handle, c);

            Ok((atoms::ok(), handle).encode(env))
        }
        Err(e) => {
            Ok((atoms::error(), e).encode(env))
        }
    }
}

fn disconnect<'a>(env: NifEnv<'a>, args: &[NifTerm<'a>]) -> NifResult<NifTerm<'a>> {
    let handle: (u32, u32) = args[0].decode()?;

    match CLIENTS.lock().unwrap().remove(&handle) {
        Some(_) => {
            Ok((atoms::ok(), handle).encode(env))
        }
        None => {
            Ok((atoms::error(), (atoms::invalid_handle(), handle)).encode(env))
        }
    }
}

fn clients<'a>(env: NifEnv<'a>, _args: &[NifTerm<'a>]) -> NifResult<NifTerm<'a>> {
    let mut keys = Vec::new();

    for (handle, client) in CLIENTS.lock().unwrap().iter() {
        keys.push((*handle, client.uri.clone()));
    }

    Ok((atoms::ok(), keys).encode(env))
}

fn add<'a>(env: NifEnv<'a>, args: &[NifTerm<'a>]) -> NifResult<NifTerm<'a>> {
    let handle: (u32, u32) = args[0].decode()?;
    let id: String = args[1].decode()?;
    let doc: String = args[2].decode()?;
    let cas: u64 = args[3].decode()?;
    let exptime: u32 = args[4].decode()?;

    match CLIENTS.lock().unwrap().get_mut(&handle) {
        Some(ref mut client) => {
            match client.add_sync(&id[..], &doc[..], cas, exptime) {
                Ok(res) => {
                    Ok((atoms::ok(), id, res.cas).encode(env))
                },
                Err((_, e)) => {
                    Ok((atoms::error(), e.to_string()).encode(env))
                }
            }

        },
        None => {
            Ok((atoms::error(), (atoms::invalid_handle(), handle)).encode(env))
        }
    }
}

fn append<'a>(env: NifEnv<'a>, args: &[NifTerm<'a>]) -> NifResult<NifTerm<'a>> {
    let handle: (u32, u32) = args[0].decode()?;
    let id: String = args[1].decode()?;
    let doc: String = args[2].decode()?;
    let cas: u64 = args[3].decode()?;
    let exptime: u32 = args[4].decode()?;

    match CLIENTS.lock().unwrap().get_mut(&handle) {
        Some(ref mut client) => {
            match client.append_sync(&id[..], &doc[..], cas, exptime) {
                Ok(res) => {
                    Ok((atoms::ok(), id, res.cas).encode(env))
                },
                Err((_, e)) => {
                    Ok((atoms::error(), e.to_string()).encode(env))
                }
            }
        },
        None => {
            Ok((atoms::error(), (atoms::invalid_handle(), handle)).encode(env))
        }
    }
}

fn get<'a>(env: NifEnv<'a>, args: &[NifTerm<'a>]) -> NifResult<NifTerm<'a>> {
    let handle: (u32, u32) = args[0].decode()?;
    let id: String = args[1].decode()?;

    match CLIENTS.lock().unwrap().get_mut(&handle) {
        Some(ref mut client) => {
            match client.get_sync(&id[..]) {
                Ok(result) => {
                    // let cas = result.cas.to_string();
                    let value = result.value.unwrap();

                    Ok((atoms::ok(), value).encode(env))
                }
                Err((_, e)) => Ok((atoms::error(), e.to_string()).encode(env))
            }
        },
        None => {
            Ok((atoms::error(), (atoms::invalid_handle(), handle)).encode(env))
        }
    }
}

fn prepend<'a>(env: NifEnv<'a>, args: &[NifTerm<'a>]) -> NifResult<NifTerm<'a>> {
    let handle: (u32, u32) = args[0].decode()?;
    let id: String = args[1].decode()?;
    let doc: String = args[2].decode()?;

    match CLIENTS.lock().unwrap().get_mut(&handle) {
        Some(ref mut client) => {
            match client.prepend_sync(&id[..], &doc[..], 0, 0) {
                Ok(_res) => {
                    Ok(atoms::ok().encode(env))
                },
                Err((_, e)) => {
                    Ok((atoms::error(), e.to_string()).encode(env))
                }
            }
        },
        None => {
            Ok((atoms::error(), (atoms::invalid_handle(), handle)).encode(env))
        }
    }
}

fn replace<'a>(env: NifEnv<'a>, args: &[NifTerm<'a>]) -> NifResult<NifTerm<'a>> {
    let handle: (u32, u32) = args[0].decode()?;
    let id: String = args[1].decode()?;
    let doc: String = args[2].decode()?;
    let cas: u64 = args[3].decode()?;
    let exptime: u32 = args[4].decode()?;

    match CLIENTS.lock().unwrap().get_mut(&handle) {
        Some(ref mut client) => {
            match client.replace_sync(&id[..], &doc[..], cas, exptime) {
                Ok(res) => {
                    Ok((atoms::ok(), id, res.cas).encode(env))
                },
                Err((_, e)) => {
                    Ok((atoms::error(), e.to_string()).encode(env))
                }
            }
        },
        None => {
            Ok((atoms::error(), (atoms::invalid_handle(), handle)).encode(env))
        }
    }
}

fn set<'a>(env: NifEnv<'a>, args: &[NifTerm<'a>]) -> NifResult<NifTerm<'a>> {
    let handle: (u32, u32) = args[0].decode()?;
    let id: String = args[1].decode()?;
    let doc: String = args[2].decode()?;
    let cas: u64 = args[3].decode()?;
    let exptime: u32 = args[4].decode()?;

    match CLIENTS.lock().unwrap().get_mut(&handle) {
        Some(ref mut client) => {
            match client.set_sync(&id[..], &doc[..], cas, exptime) {
                Ok(res) => {
                    Ok((atoms::ok(), id, res.cas).encode(env))
                },
                Err((_, e)) => {
                    Ok((atoms::error(), e.to_string()).encode(env))
                }
            }
        },
        None => {
            Ok((atoms::error(), (atoms::invalid_handle(), handle)).encode(env))
        }
    }
}

fn upsert<'a>(env: NifEnv<'a>, args: &[NifTerm<'a>]) -> NifResult<NifTerm<'a>> {
    let handle: (u32, u32) = args[0].decode()?;
    let id: String = args[1].decode()?;
    let doc: String = args[2].decode()?;
    let cas: u64 = args[3].decode()?;
    let exptime: u32 = args[4].decode()?;

    match CLIENTS.lock().unwrap().get_mut(&handle) {
        Some(ref mut client) => {
            match client.upsert_sync(&id[..], &doc[..], cas, exptime) {
                Ok(res) => {
                    Ok((atoms::ok(), id, res.cas).encode(env))
                },
                Err((_, e)) => {
                    Ok((atoms::error(), e.to_string()).encode(env))
                }
            }
        },
        None => {
            Ok((atoms::error(), (atoms::invalid_handle(), handle)).encode(env))
        }
    }
}