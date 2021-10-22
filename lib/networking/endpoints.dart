
/// Base url of our endpoints
const BASE_URL = "https://fumzzy-app.herokuapp.com/";

/// Endpoints regarding staff(user)
const SIGN_UP = BASE_URL + "user/signup";
const LOGIN = BASE_URL + "user/login";
const GET_ALL_USERS = BASE_URL + "user/getAll";
const USER_ACTION = BASE_URL + "user/action";
const EDIT_USER = BASE_URL + "user/edit";
const CHANGE_PIN = BASE_URL + "user/changePin";

/// Endpoints regarding expenses
const CREATE_EXPENSES = BASE_URL + "expenses/create";
const GET_ALL_EXPENSES = BASE_URL + "expenses/getAll";
const DELETE_EXPENSES = BASE_URL + "expenses/delete";

/// Endpoints regarding category
const CREATE_CATEGORY = BASE_URL + "category/create";

/// Endpoints for user actions(reset,block,delete)
const RESET_PIN = BASE_URL + "user/resetPin/613de35cf3c9c70a726e6774";