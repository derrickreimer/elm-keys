# Keyboard Events for Elm

This library provides keyboard event functions, similar to the helpers provided in [Html.Events](http://package.elm-lang.org/packages/elm-lang/html/latest/Html-Events).

[![Travis build status](https://travis-ci.org/derrickreimer/elm-keys.svg?branch=master)](https://travis-ci.org/derrickreimer/elm-keys)

## Usage

The core event types this library supports are `keydown`, `keypress`, and `keyup`. Since it's often necessary to listen for multiple keyboard events on a given form control, the event functions accept a list of listener criteria that map to particular message constructor.

Suppose you have a `<textarea>` and you would like to:

- Close the editor when the user presses `Esc`,
- Submit the value when `Meta + Enter` is pressed (on a Mac, the meta key is Command), and
- Prevent the default behavior when either of those keys are pressed.

Your program (partially) might look something like this:

```elm
import Keys exposing (Modifier(..), KeyboardEvent, preventDefault, onKeydown)


type Msg
    = MetaEnterPressed KeyboardEvent
    | EscPressed KeyboardEvent


view : Html Msg
view =
    textarea
        [ onKeydown preventDefault
            [ ( [ Meta ], Keys.enter, MetaEnterPressed )
            , ( [], Keys.esc, EscPressed )
            ]
        ]
        []


-- Other program details omitted
```

The first argument is a set of options (see [`Html.Events` options](http://package.elm-lang.org/packages/elm-lang/html/latest/Html-Events#Options)).

The second is a list of three-part tuples containing:

- a list of modifier keys,
- a key code, and
- a message constructor.
