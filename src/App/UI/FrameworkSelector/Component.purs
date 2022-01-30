module App.UI.FrameworkSelector.Component where

import Prelude

import Effect.Aff.Class (class MonadAff)
import Halogen as H
import App.Data.Types (Framework(..))
import Ocelot.Dropdown as D
import Data.Maybe (Maybe(..))
import Type.Proxy (Proxy(..))
import Ocelot.Block.Button as Button
import Halogen.HTML as HH


-- State is internal to the component and the type is opaque to the
-- parent or any child. Similar to 'State' in React.
type State = 
  { selectedFramework :: Maybe Framework
  }

-- 'Action' is the type of events the component can raise and handle
-- within itself. It is opaque to the parent or any child.
data Action 
  = HandleDropdown (D.Output Framework) 

defaultState :: State
defaultState = 
  { selectedFramework: Nothing
  }

-- 'Message' is the type used to (one-way) communicate from child to parent. 
-- This component has no messages to emit to its parent. 
type Message = Void

-- 'Query' is a way for a parent to provoke to child to do something. 
-- This component cannot be queried by its parent.
data Query :: forall k. k -> Type
data Query a

-- This component does not require input from its parent to 
-- initialize its state. Similar to 'Props' in React.
type Input = Unit

_frameworkDropdown :: Proxy "frameworkDropdown"
_frameworkDropdown = Proxy

component
  :: forall m
   . MonadAff m
  => H.Component Query Input Message m
component =
  H.mkComponent
    { initialState: const defaultState
    , render
    , eval:
        H.mkEval
          $ H.defaultEval
              { handleAction = handleAction
              }
    }
  where
    -- Here we declare how we handle each internal action the component
    -- can raise.
    handleAction (HandleDropdown msg) = case msg of
      D.Selected a -> H.modify_ _{selectedFramework = Just a}
      _ -> pure unit
    
    render st = 
      HH.div_
        [ HH.text txt
        -- 'slot' is the function to embed a child component. Notice when we
        -- embed the dropdown child, we handle all emitted messages with the
        -- 'HandleDropdown' action.
        , HH.slot _frameworkDropdown unit D.component dropdownInput HandleDropdown
        ]

      where 
        -- input to initialize the dropdown.
        dropdownInput :: D.Input Framework m
        dropdownInput = 
            { disabled: false
            , items: options
            , render: D.defDropdown Button.button [] show "Pick One"
            , selectedItem: Nothing
            }
        options = [Halogen, React, ReactBasic, SomethingElse]
        txt = case st.selectedFramework of
          Nothing -> "Select a PureScript frontend framework!"
          Just a -> "Let's use " <> show a <> "!"