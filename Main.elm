port module Main exposing (main)

import Html exposing (Html)
import Html.Events


type alias Model =
    { jenkinsProjects : List JenkinsProject
    }


type alias JenkinsProject =
    { name : String
    , url : String
    }


initialModel : Model
initialModel =
    { jenkinsProjects = []
    }


type Msg
    = NewJenkinsProjects (List JenkinsProject)
    | OpenExternal String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewJenkinsProjects projects ->
            ( { model | jenkinsProjects = projects }
            , Cmd.none
            )

        OpenExternal url ->
            ( model
            , openExternal url
            )


viewProject : JenkinsProject -> Html Msg
viewProject project =
    Html.li []
        [ Html.a [ Html.Events.onClick (OpenExternal project.url) ]
            [ Html.text project.name
            ]
        ]


view : Model -> Html Msg
view model =
    Html.ul [] (List.map viewProject model.jenkinsProjects)


main : Program Never Model Msg
main =
    Html.program
        { init = ( initialModel, Cmd.none )
        , update = update
        , subscriptions = \model -> jenkinsProjects NewJenkinsProjects
        , view = view
        }


port jenkinsProjects : (List JenkinsProject -> msg) -> Sub msg


port openExternal : String -> Cmd msg
