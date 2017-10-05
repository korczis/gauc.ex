#![feature(link_args)]
#![feature(plugin)]
#![plugin(rustler_codegen)]
#[cfg(target_os="macos")]
#[link_args = "-flat_namespace -undefined suppress"]
extern {}

#[macro_use]
extern crate rustler;

#[macro_use]
extern crate lazy_static;

extern crate gauc;

use rustler::{NifEnv, NifTerm, NifEncoder, NifResult};
//use rustler::resource::ResourceCell;
//use rustler::atom::{init_atom, get_atom};
//use rustler::tuple::make_tuple;
//use rustler::binary::OwnedNifBinary;

static mut client: gauc::client::Client = gauc::client::Client {
    instance: None,
    opts: None,
    uri: None
};

mod atoms {
    rustler_atoms! {
        atom ok;
        //atom error;
        //atom __true__ = "true";
        //atom __false__ = "false";
    }
}

rustler_export_nifs! {
    "Elixir.Gauc.Native",
    [
      ("connect", 0, connect),
      ("add", 2, add),
      ("append", 2, append),
      ("get", 1, get),
      ("prepend", 2, prepend),
      ("replace", 2, replace),
      ("set", 2, set),
      ("upsert", 2, upsert)
    ],
    Some(on_load)
}

fn on_load(env: NifEnv, load_info: NifTerm) -> bool {
    // resource_struct_init!(FileResource, env);

    true
}

fn connect<'a>(env: NifEnv<'a>, args: &[NifTerm<'a>]) -> NifResult<NifTerm<'a>> {
    unsafe {
        client.connect("couchbase://localhost/default");
        let version = client.opts.as_ref().unwrap().lock().unwrap().version();

        Ok((atoms::ok(), version).encode(env))
    }
}

fn add<'a>(env: NifEnv<'a>, args: &[NifTerm<'a>]) -> NifResult<NifTerm<'a>> {
    let id: String = try!(args[0].decode());
    let doc: String = try!(args[1].decode());

    unsafe {
        let _ = client.add_sync(&id[..], &doc[..], 0, 0);
        Ok((atoms::ok(), 0).encode(env))
    }
}

fn append<'a>(env: NifEnv<'a>, args: &[NifTerm<'a>]) -> NifResult<NifTerm<'a>> {
    let id: String = try!(args[0].decode());
    let doc: String = try!(args[1].decode());

    unsafe {
        let _ = client.append_sync(&id[..], &doc[..], 0, 0);
        Ok((atoms::ok(), 0).encode(env))
    }
}

fn get<'a>(env: NifEnv<'a>, args: &[NifTerm<'a>]) -> NifResult<NifTerm<'a>> {
    let id: String = try!(args[0].decode());

    unsafe {
        let response = client.get_sync(&id[..], 0);
        match response {
            Ok(result) => {
                let cas = result.cas.to_string();
                let value = result.value.unwrap();

                Ok((atoms::ok(), value).encode(env))
            }
            _ => Ok((atoms::ok(), String::from("")).encode(env))
        }
    }
}

fn prepend<'a>(env: NifEnv<'a>, args: &[NifTerm<'a>]) -> NifResult<NifTerm<'a>> {
    let id: String = try!(args[0].decode());
    let doc: String = try!(args[1].decode());

    unsafe {
        let _ = client.prepend_sync(&id[..], &doc[..], 0, 0);
        Ok((atoms::ok(), 0).encode(env))
    }
}

fn replace<'a>(env: NifEnv<'a>, args: &[NifTerm<'a>]) -> NifResult<NifTerm<'a>> {
    let id: String = try!(args[0].decode());
    let doc: String = try!(args[1].decode());

    unsafe {
        let _ = client.replace_sync(&id[..], &doc[..], 0, 0);
        Ok((atoms::ok(), 0).encode(env))
    }
}

fn set<'a>(env: NifEnv<'a>, args: &[NifTerm<'a>]) -> NifResult<NifTerm<'a>> {
    let id: String = try!(args[0].decode());
    let doc: String = try!(args[1].decode());

    unsafe {
        let _ = client.set_sync(&id[..], &doc[..], 0, 0);
        Ok((atoms::ok(), 0).encode(env))
    }
}

fn upsert<'a>(env: NifEnv<'a>, args: &[NifTerm<'a>]) -> NifResult<NifTerm<'a>> {
    let id: String = try!(args[0].decode());
    let doc: String = try!(args[1].decode());

    unsafe {
        let _ = client.upsert_sync(&id[..], &doc[..], 0, 0);
        Ok((atoms::ok(), 0).encode(env))
    }
}