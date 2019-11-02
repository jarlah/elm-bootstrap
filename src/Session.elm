module Session exposing (..)

import Browser.Navigation as Nav
import Flags exposing (Flags)


type alias Session =
    { navKey : Nav.Key
    , flags : Flags
    }


fromFlags : Nav.Key -> Flags -> Session
fromFlags navKey flags =
    { navKey = navKey, flags = flags }
