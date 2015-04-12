# elm-localstorage

LocalStorage task adapter for Elm

```elm
import Graphics.Element exposing (..)
import LocalStorage


hello : Signal.Mailbox String
hello =
  Signal.mailbox "loading"


main : Signal Element
main =
  Signal.map show hello.signal


port runHello : Task LocalStorage.Error ()
port runHello =
  (LocalStorage.get "some-key") `andThen` Signal.send hello.address
```
