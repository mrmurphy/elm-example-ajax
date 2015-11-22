module App.GitHubUsers (parseUsers, apiUrl) where

import Json.Decode as Json exposing ((:=))
import List exposing (map)
import App.User exposing (User)

type alias GhUser =
  { login: String
  , avatar_url: String
  }

ghUserToUser : GhUser -> User
ghUserToUser u =
  {name = u.login, avatar = u.avatar_url}


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

parseUsers : String -> List User
parseUsers jsonString =
    safeDecodeUser
    (Json.decodeString userListDecoder jsonString)

apiUrl : String
apiUrl =
  "https://api.github.com/users"
