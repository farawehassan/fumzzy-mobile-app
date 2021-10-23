
/// Base url of our endpoints
const BASE_URL = "https://fumzzy-app.herokuapp.com/";

/// Endpoints regarding staff(user)
const SIGN_UP = BASE_URL + "user/signup";
const LOGIN = BASE_URL + "user/login";
const GET_ALL_USERS = BASE_URL + "user/getAll";
const USER_ACTION = BASE_URL + "user/action";

/// Endpoints regarding expenses
const CREATE_EXPENSES = BASE_URL + "expenses/create";
const GET_ALL_EXPENSES = BASE_URL + "expenses/getAll";
const DELETE_EXPENSES = BASE_URL + "expenses/delete";

/// Endpoints regarding products(inventory)
const CREATE_PRODUCT = BASE_URL + "product/add";
const GET_ALL_PRODUCTS = BASE_URL + "product/fetchAll";
const GET_A_PRODUCT = BASE_URL + "product/fetch/616be222fc1be9ae8103b007";
const UPDATE_A_PRODUCT = BASE_URL + "product/update/616be222fc1be9ae8103b007";
const DELETE_PRODUCT = BASE_URL + "product/delete";

/// Endpoints regarding product categories
const GET_ALL_CATEGORIES = BASE_URL + "category/getAll";
const CREATE_A_CATEGORY = BASE_URL + "category/create";
const EDIT_CATEGORY = BASE_URL + "category/edit";
const DELETE_CATEGORY = BASE_URL + "category/delete/61574cfba25889e25fa63422";

