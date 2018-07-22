defmodule MyAppWeb.Schema do
  use Absinthe.Schema
  import_types MyAppWeb.Schema.Types

  query do
    field :posts, list_of(:post) do
      resolve &MyApp.PostResolver.all/2
    end

    field :users, list_of(:user) do
      resolve &MyApp.UserResolver.all/2
    end

    field :user, type: :user do
      arg :id, non_null(:id)
      resolve &MyApp.UserResolver.find/2
    end
  end

  input_object :update_post_params do
    field :title, non_null(:string)
    field :body, non_null(:string)
    field :user_id, non_null(:integer)
  end

  mutation do
    field :create_post, type: :post do
      arg :title, non_null(:string)
      arg :body, non_null(:string)
      arg :user_id, non_null(:integer)

      resolve &MyApp.PostResolver.create/2
    end

    field :update_post, type: :post do
      arg :id, non_null(:integer)
      arg :post, :update_post_params

      resolve &MyApp.PostResolver.update/2
    end

    field :delete_post, type: :post do
      arg :id, non_null(:integer)

      resolve &MyApp.PostResolver.delete/2
    end
  end

  subscription do
    field :post_added, :post do
      arg :user_id, non_null(:integer)

      config fn args, _ ->
        {:ok, topic: args.user_id}
      end

      trigger :create_post, topic: fn post ->
        post.user_id
      end

      resolve fn post, _, _ ->
        {:ok, post}
      end
    end
  end
end
