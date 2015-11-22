module App.User (User, view) where

import Html exposing (..)
import Html.Attributes exposing (class, style)

type alias User =
  { name : String
  , avatar : String
  }


avatar : String -> Html
avatar url =
  div
    [ class "avatar"
    , style [("background-image", "url(" ++ url ++ ")" )]
    ]
    []


view : User -> Html
view user =
  li [class "user"]
    [ avatar user.avatar
    , div [class "name"] [text user.name]
    ]
