port module Main exposing (main)

import Html exposing (Html)
import Html.Events
import Json.Decode as Decode


type alias Model =
    { jenkinsProjects : List JenkinsProject
    }


type alias JenkinsProject =
    { name : String
    , url : String
    , color : Maybe String
    }


projectDecoder : Decode.Decoder JenkinsProject
projectDecoder =
    Decode.map3 JenkinsProject
        (Decode.field "name" Decode.string)
        (Decode.field "url" Decode.string)
        (Decode.maybe (Decode.field "color" Decode.string))


initialModel : Model
initialModel =
    { jenkinsProjects = []
    }


type Msg
    = NewJenkinsProjects (List Decode.Value)
    | OpenExternal String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewJenkinsProjects jsons ->
            let
                projects =
                    jsons
                        |> List.map (Decode.decodeValue projectDecoder)
                        |> List.map okOrCrash

                okOrCrash : Result String a -> a
                okOrCrash result =
                    case result of
                        Ok a ->
                            a

                        Err message ->
                            Debug.crash message
            in
            ( { model | jenkinsProjects = projects }
            , Cmd.none
            )

        OpenExternal url ->
            ( model
            , openExternal url
            )


viewProject : JenkinsProject -> Html Msg
viewProject project =
    Html.li [] <|
        [ Html.a [ Html.Events.onClick (OpenExternal project.url) ]
            [ Html.text project.name
            ]
        ]


filterBuilds : JenkinsProject -> Bool
filterBuilds project =
    if project.color == Just "yellow_anime" then
        True
    else
        False


view : Model -> Html Msg
view model =
    Html.div []
        [ Html.h3 [] [ Html.text "Building" ]
        , model.jenkinsProjects
            |> List.filter filterBuilds
            |> List.map viewProject
            |> Html.ul []
        ]


main : Program Never Model Msg
main =
    Html.program
        { init = ( initialModel, Cmd.none )
        , update = update
        , subscriptions = \model -> jenkinsProjects NewJenkinsProjects
        , view = view
        }


port jenkinsProjects : (List Decode.Value -> msg) -> Sub msg


port openExternal : String -> Cmd msg
