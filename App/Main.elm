module App.Main where

import StartApp as StartApp
import App.UserList as UserList
import Task
import Effects exposing (Never)


app =
  StartApp.start
    { init = UserList.init []
    , update = UserList.update
    , view = UserList.view
    , inputs = []
    }


main =
  app.html


port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks
