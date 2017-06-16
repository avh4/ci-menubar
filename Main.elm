port module Main exposing (main)

import Html


type alias Model =
    { theString : String
    }


initialModel : Model
initialModel =
    { theString = "Waiting..."
    }


type Msg
    = NewTheString (List String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewTheString strings ->
            ( { model | theString = String.join "," strings }
            , Cmd.none
            )


main : Program Never Model Msg
main =
    Html.program
        { init = ( initialModel, Cmd.none )
        , update = update
        , subscriptions = \model -> suggestions NewTheString
        , view = \model -> Html.text model.theString
        }


port suggestions : (List String -> msg) -> Sub msg
