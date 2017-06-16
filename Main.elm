port module Main exposing (main)

import Html


type alias Model =
    { jenkinsProjects : List JenkinsProject
    }


type alias JenkinsProject =
    { name : String
    }


initialModel : Model
initialModel =
    { jenkinsProjects = []
    }


type Msg
    = NewJenkinsProjects (List JenkinsProject)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewJenkinsProjects projects ->
            ( { model | jenkinsProjects = projects }
            , Cmd.none
            )


main : Program Never Model Msg
main =
    Html.program
        { init = ( initialModel, Cmd.none )
        , update = update
        , subscriptions = \model -> jenkinsProjects NewJenkinsProjects
        , view = \model -> Html.text <| toString model
        }


port jenkinsProjects : (List JenkinsProject -> msg) -> Sub msg
