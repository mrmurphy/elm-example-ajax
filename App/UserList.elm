module App.UserList (init, update, view) where

import Effects exposing (Effects, Never)
import Task
import Http
import Html exposing (..)
import Html.Attributes exposing (class)
import List exposing (map)

import App.User as User exposing (User)
import App.GitHubUsers as GitHubUsers

-- Model

type alias Model =
  List User


init : Model -> (Model, Effects Action)
init currentUsers =
  ( currentUsers
  , getUsers
  )


-- Update

type Action
  = Refetch
  | ReceiveUsers (Maybe (List User))


update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    Refetch ->
      (model, getUsers)

    ReceiveUsers maybeUsers ->
      ( Maybe.withDefault [] maybeUsers
      , Effects.none
      )

-- View

view : Signal.Address Action -> List User -> Html
view address userList =
  div [class "wrapper"]
  [ h1 [] [text "Users"]
  , ul [class "userList"] (map User.view userList)
  ]

-- Effects

getUsers : Effects Action
getUsers =
  Http.getString GitHubUsers.apiUrl
    |> Task.map GitHubUsers.parseUsers
    |> Task.toMaybe
    |> Task.map ReceiveUsers
    |> Effects.task
