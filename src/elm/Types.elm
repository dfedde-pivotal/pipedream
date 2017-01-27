module Types exposing (..)


type Msg
    = NoOp
    | Submit
    | Join String Get
    | Select String


type alias Get =
    { name : String
    , passed : List String
    }


type alias Job =
    { name : String
    ,gets : List Get
    }


type alias Model =
    { jobs : List Job
    , focused : Maybe String
    }
