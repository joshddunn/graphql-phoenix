defmodule MyAppWeb.Router do
  use MyAppWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MyAppWeb do
    pipe_through :api
    resources "/users", UserController, except: [:new, :edit]
    resources "/posts", PostController, except: [:new, :edit]
  end

  forward "/api", Absinthe.Plug,
    schema: MyAppWeb.Schema

  forward "/graphiql", Absinthe.Plug.GraphiQL,
    schema: MyAppWeb.Schema,
    socket: MyAppWeb.UserSocket
end
