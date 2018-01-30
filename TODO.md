# TODO

- [ ] Opaque & Immutable handles
  - [ ] Track
  - [ ] Release - disconnect
- [ ] Async API (Client)
- [ ] Documents API
  - [ ] Client.insert("id", %{name: "doc"})

  {:ok, handle} = Gauc.Client.connect("couchbase://localhost/default", "Administrator", "Administrator")
  {:ok, res} = Gauc.Client.query_view(handle, "cap", "all")