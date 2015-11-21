module App.Main where
import Http
import Html exposing (Html, text, div, li, ul, h1, img)
import Html.Attributes  exposing (class, style)
import Task exposing (Task, andThen)
import List exposing (map)
import Json.Decode as Json exposing ((:=))

type alias GhUser =
  { login: String
  , avatar_url: String
  }

type alias User =
  { name : String
  , avatar : String
  }

ghUserToUser : GhUser -> User
ghUserToUser u =
  {name = u.login, avatar = u.avatar_url}

avatar : String -> Html
avatar url =
  div
    [ class "avatar"
    , style [("background-image", "url(" ++ url ++ ")" )]
    ]
    []

renderUser : User -> Html
renderUser u =
  li [class "user"]
    [ avatar u.avatar
    , div [class "name"] [text u.name]
    ]

renderUserList : List User -> Html
renderUserList userList =
  div [class "wrapper"]
  [ h1 [] [text "Users"]
  , ul [class "userList"] (map renderUser userList)
  ]

userListDecoder : Json.Decoder (List GhUser)
userListDecoder =
  Json.list <| Json.object2 GhUser
    ("login" := Json.string)
    ("avatar_url" := Json.string)

safeDecodeUser : Result String (List GhUser) -> (List User)
safeDecodeUser result =
  case result of
    Err msg ->
      []
    Ok users ->
      map ghUserToUser users

parse : String -> List User
parse jsonString =
    safeDecodeUser
    (Json.decodeString userListDecoder jsonString)

usersUrl : String
usersUrl =
  "https://api.github.com/users"

handleResponse : String -> Task x ()
handleResponse json =
  Signal.send userBox.address (parse json)

port fetchUsers : Task Http.Error ()
port fetchUsers =
  Http.getString usersUrl `andThen` handleResponse

userBox : Signal.Mailbox (List User)
userBox =
  Signal.mailbox []

main : Signal Html
main =
  Signal.map renderUserList userBox.signal
