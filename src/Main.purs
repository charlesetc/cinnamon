module Main where

import Prelude

import Effect (Effect)
import App.UI.FrameworkSelector.Component as FrameworkSelector
import Halogen.Aff as HA
import Halogen.VDom.Driver (runUI)

main :: Effect Unit
main = HA.runHalogenAff do
  body <- HA.awaitBody
  runUI FrameworkSelector.component unit body