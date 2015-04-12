
module LocalStorage
  (get, set, remove, getJson, Error(..)) where

import Native.LocalStorage
import String
import Task exposing (Task, andThen, succeed, fail)
import Json.Decode as Json
import Maybe exposing (Maybe(..))

type Error
  = NoStorage
  | UnexpectedPayload String

get : String -> Task Error (Maybe String)
get =
  Native.LocalStorage.get

-- Convenience json decoder that shortcuts nothing maybes
getJson : Json.Decoder value -> String -> Task Error (Maybe value)
getJson decoder key =
  let decode maybe =
    case maybe of
      Just str -> fromJson decoder str
      Nothing -> succeed Nothing
  in
    (get key) `andThen` decode

-- Decodes json and handles parse errors
fromJson : Json.Decoder value -> String -> Task Error (Maybe value)
fromJson decoder str =
  case Json.decodeString decoder str of
    Ok v -> succeed (Just v)
    Err msg -> fail (UnexpectedPayload msg)

-- Passes through string value as result for chaining. Possible NoStorage error
set : String -> String -> Task Error String
set =
  Native.LocalStorage.set 

-- Passes through string key as result for chaining. Possible NoStorage error
remove : String -> Task Error String
remove key =
  Native.LocalStorage.remove
