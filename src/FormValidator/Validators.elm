module FormValidator.Validators exposing
  (
    isBlank,
    isEmpty,
    isInteger,
    isFloat,
    isIncluded,
    isExcluded,
    isGreaterThan,
    isLessThan,
    isBetween,
    isLengthGreaterThanEqualTo,
    isLengthLessThanEqualTo,
    isEmail
  )

{-|

The Form Validator validators provide the functionality needed for validating a form field. These
can be mixed and matched as desired.

@docs isBlank, isEmpty, isInteger, isFloat, isIncluded, isExcluded, isGreaterThan, isLessThan
@docs isBetween, isLengthGreaterThanEqualTo, isLengthLessThanEqualTo, isEmail

-}

import Regex
import FormValidator.Models as Models
import FormValidator.Patterns as Patterns

{-| Check if value is blank. -}
isBlank : Models.Value -> Models.Error
isBlank value =
  if Regex.contains Patterns.blank value then
    Just "Must not be blank."
  else
    Nothing

{-| Check if value is empty. -}
isEmpty : Models.Value -> Models.Error
isEmpty value =
  if String.isEmpty value then
    Just "Must have at least one selection."
  else
    Nothing

{-| Check if value is an integer. -}
isInteger : Models.Value -> Models.Error
isInteger value =
  case String.toInt value of
    Ok _ ->
      Nothing
    Err _ ->
      Just "Must be a number."

{-| Check if value is a float. -}
isFloat : Models.Value -> Models.Error
isFloat value =
  case String.toFloat value of
    Ok _ ->
      Nothing
    Err _ ->
      Just "Must be a decimal."

{-| Check if value is included in list. -}
isIncluded : List String -> Models.Value -> Models.Error
isIncluded includes value =
  if List.member value includes then
    Nothing
  else
    Just <| "Invalid choice: " ++ value ++ ". Use: " ++ (String.join ", " includes) ++ "."

{-| Check if value is excluded from list. -}
isExcluded : List String -> Models.Value -> Models.Error
isExcluded excludes value =
  if List.member value excludes then
    Just <| "Invalid choice: " ++ value ++ ". Avoid: " ++ (String.join ", " excludes) ++ "."
  else
    Nothing

{-| Check if value is greater than minimum. -}
isGreaterThan : Int -> Models.Value -> Models.Error
isGreaterThan minimum value =
  let
    number = Result.withDefault 0 <| String.toInt value
  in
    if number > minimum then
      Nothing
    else
      Just ("Must be greater than " ++ (toString minimum) ++ ".")

{-| Check if value is less than maximum. -}
isLessThan : Int -> Models.Value -> Models.Error
isLessThan maximum value =
  let
    number = Result.withDefault 0 <| String.toInt value
  in
    if number < maximum then
      Nothing
    else
      Just ("Must be less than " ++ (toString maximum) ++ ".")

{-| Check if value is minimum and maximum. -}
isBetween : Int -> Int -> Models.Value -> Models.Error
isBetween minimum maximum value =
  let
    number = Result.withDefault 0 <| String.toInt value
  in
    if number >= minimum && number <= maximum then
      Nothing
    else
      Just ("Must be between " ++ (toString minimum) ++ " and " ++ (toString maximum) ++ ".")

{-| Check if value length is greater than or equal to minimum. -}
isLengthGreaterThanEqualTo : Int -> Models.Value -> Models.Error
isLengthGreaterThanEqualTo minimum value =
  if String.length value >= minimum then
    Nothing
  else
    Just ("Must be greater than or equal to " ++ (toString minimum) ++ " characters.")

{-| Check if value length is less than or equal to maximum. -}
isLengthLessThanEqualTo : Int -> Models.Value -> Models.Error
isLengthLessThanEqualTo maximum value =
  if String.length value <= maximum then
    Nothing
  else
    Just ("Must be less than or equal to " ++ (toString maximum) ++ " characters.")

{-| Check if value is an email address. -}
isEmail : Models.Value -> Models.Error
isEmail value =
  if Regex.contains Patterns.email value then
    Nothing
  else
    Just "Must be an email address."
