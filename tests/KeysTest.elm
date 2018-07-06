module KeysTest exposing (..)

import Expect exposing (Expectation)
import Html exposing (Attribute)
import Html.Events exposing (Options)
import Json.Encode as Encode exposing (Value, bool, int)
import Keys exposing (KeyboardEvent, Modifier(..), Listener, defaultOptions, onKeydown, onKeypress, onKeyup)
import Test exposing (..)
import Test.Html.Event as Event
import Test.Html.Query as Query


type Msg
    = EventFired KeyboardEvent



-- SUITE


suite : Test
suite =
    describe "events"
        [ eventTests "keydown" onKeydown
        , eventTests "keypress" onKeypress
        , eventTests "keyup" onKeyup
        ]



-- INTERNAL


eventTests : String -> (Options -> List (Listener Msg) -> Attribute Msg) -> Test
eventTests action listener =
    describe action
        [ test "matches given a single without modifiers" <|
            \_ ->
                Html.textarea [ listener defaultOptions [ ( [], Keys.enter, EventFired ) ] ] []
                    |> Query.fromHtml
                    |> Event.simulate (enter action)
                    |> Event.expect (EventFired (KeyboardEvent Keys.enter [] False))
        , test "does not match listeners with mismatching modifiers" <|
            \_ ->
                Html.textarea [ listener defaultOptions [ ( [], Keys.enter, EventFired ) ] ] []
                    |> Query.fromHtml
                    |> Event.simulate (shiftEnter action)
                    |> Event.toResult
                    |> Expect.equal (Err "I ran into a `fail` decoder: no match")
        , test "does not match listeners with mismatching key codes" <|
            \_ ->
                Html.textarea [ listener defaultOptions [ ( [], Keys.enter, EventFired ) ] ] []
                    |> Query.fromHtml
                    |> Event.simulate (esc action)
                    |> Event.toResult
                    |> Expect.equal (Err "I ran into a `fail` decoder: no match")
        , test "matches when one of multiple listeners match" <|
            \_ ->
                Html.textarea
                    [ listener defaultOptions
                        [ ( [], Keys.enter, EventFired )
                        , ( [], Keys.esc, EventFired )
                        ]
                    ]
                    []
                    |> Query.fromHtml
                    |> Event.simulate (esc action)
                    |> Event.expect (EventFired (KeyboardEvent Keys.esc [] False))
        , test "matches with modifiers" <|
            \_ ->
                Html.textarea
                    [ listener defaultOptions
                        [ ( [ Ctrl, Shift ], Keys.enter, EventFired )
                        ]
                    ]
                    []
                    |> Query.fromHtml
                    |> Event.simulate (ctrlShiftEnter action)
                    |> Event.expect (EventFired (KeyboardEvent Keys.enter [ Ctrl, Shift ] False))
        ]


shiftEnter : String -> ( String, Value )
shiftEnter action =
    let
        props =
            Encode.object
                [ ( "keyCode", int Keys.enter )
                , ( "shiftKey", bool True )
                , ( "metaKey", bool False )
                , ( "ctrlKey", bool False )
                , ( "altKey", bool False )
                , ( "repeat", bool False )
                ]
    in
        Event.custom action props


ctrlShiftEnter : String -> ( String, Value )
ctrlShiftEnter action =
    let
        props =
            Encode.object
                [ ( "keyCode", int Keys.enter )
                , ( "shiftKey", bool True )
                , ( "metaKey", bool False )
                , ( "ctrlKey", bool True )
                , ( "altKey", bool False )
                , ( "repeat", bool False )
                ]
    in
        Event.custom action props


enter : String -> ( String, Value )
enter action =
    let
        props =
            Encode.object
                [ ( "keyCode", int Keys.enter )
                , ( "shiftKey", bool False )
                , ( "metaKey", bool False )
                , ( "ctrlKey", bool False )
                , ( "altKey", bool False )
                , ( "repeat", bool False )
                ]
    in
        Event.custom action props


esc : String -> ( String, Value )
esc action =
    let
        props =
            Encode.object
                [ ( "keyCode", int Keys.esc )
                , ( "shiftKey", bool False )
                , ( "metaKey", bool False )
                , ( "ctrlKey", bool False )
                , ( "altKey", bool False )
                , ( "repeat", bool False )
                ]
    in
        Event.custom action props
