module Main exposing (main)

import Html


type alias Model =
    { theString : String
    }


initialModel : Model
initialModel =
    { theString = "Waiting..."
    }


type Msg
    = NewTheString String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewTheString string ->
            ( { model | theString = string }
            , Cmd.none
            )


main : Program Never Model Msg
main =
    Html.program
        { init = ( initialModel, Cmd.none )
        , update = update
        , subscriptions = \model -> Sub.none
        , view = \model -> Html.text model.theString
        }
