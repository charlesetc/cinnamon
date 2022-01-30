module App.Data.Types where

import Prelude

data Framework
 = Halogen
 | React
 | ReactBasic
 | SomethingElse

derive instance Eq Framework
derive instance Ord Framework
instance Show Framework where
  show = case _ of
    Halogen -> "Halogen"
    React -> "React"
    ReactBasic -> "React Basic"
    SomethingElse -> "Something Else"