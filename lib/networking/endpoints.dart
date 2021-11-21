/// Base url of our endpoints
const BASE_URL = 'https://fumzzy-app.herokuapp.com/';

/// Endpoints regarding staff(user)
const SIGN_UP = BASE_URL + 'user/signup';
const LOGIN = BASE_URL + 'user/login';
const GET_ALL_USERS = BASE_URL + 'user/getAll';
const GET_CURRENT_USER = BASE_URL + 'user/getCurrentUser';
const USER_ACTION = BASE_URL + 'user/action';
const EDIT_USER = BASE_URL + 'user/edit';
const CHANGE_PIN = BASE_URL + 'user/changePin';
const RESET_PIN = BASE_URL + 'user/resetPin';

/// Endpoints regarding expenses
const CREATE_EXPENSES = BASE_URL + 'expenses/create';
const GET_ALL_EXPENSES = BASE_URL + 'expenses/getAll';
const DELETE_EXPENSES = BASE_URL + 'expenses/delete';

/// Endpoints regarding products(inventory)
const CREATE_PRODUCT = BASE_URL + 'product/add';
const GET_ALL_PRODUCTS_PAGINATED = BASE_URL + 'product/fetchAll';
const GET_ALL_PRODUCTS = BASE_URL + 'product/fetchAllProducts';
const GET_A_PRODUCT = BASE_URL + 'product/fetch/616be222fc1be9ae8103b007';
const UPDATE_A_PRODUCT = BASE_URL + 'product/update';
const DELETE_PRODUCT = BASE_URL + 'product/delete';

/// Endpoints regarding product categories
const GET_ALL_CATEGORIES = BASE_URL + 'category/getAll';
const CREATE_CATEGORY = BASE_URL + 'category/create';
const EDIT_CATEGORY = BASE_URL + 'category/edit';
const DELETE_CATEGORY = BASE_URL + 'category/delete/61574cfba25889e25fa63422';

/// Endpoints regarding purchases
const GET_ALL_PURCHASES_PAGINATED = BASE_URL + 'purchase/fetchAll';
const GET_ALL_PURCHASES = BASE_URL + 'purchase/fetchAllPurchases';
const GET_PURCHASES_BY_PRODUCT = BASE_URL + 'purchase/fetchAllPurchasesByProduct';
const DELETE_PURCHASE = BASE_URL + 'purchase/delete';

/// Endpoints regarding sales
const ADD_SALES = BASE_URL + 'sales/addNew';
const GET_ALL_SALES = BASE_URL + 'sales/fetchAll';
const UPDATE_SALE_PRODUCT_NAME = BASE_URL + 'sales/updateSalesName';
const DELETE_SALE = BASE_URL + 'sales/delete';

/// Endpoints regarding customer
const ADD_NEW_CUSTOMER = BASE_URL + 'customer/addNew';
const ADD_NEW_REPORTS_TO_CUSTOMER = BASE_URL + 'customer/addNewCustomerReports';
const ADD_PREVIOUS_CUSTOMER = BASE_URL + 'customer/addPrevious';
const ADD_PREVIOUS_CUSTOMER_REPORTS = BASE_URL + 'customer/addNewPreviousCustomerReports';
const GET_ALL_CUSTOMERS = BASE_URL + 'customer/fetchAll';
const GET_ALL_DEBTORS = BASE_URL + 'customer/fetchAllDebtors';
const GET_ALL_CUSTOMERS_NAME = BASE_URL + 'customer/fetchCustomersName';
const GET_A_CUSTOMER = BASE_URL + 'customer/fetchCustomer';
const UPDATE_CUSTOMER_REPORT = BASE_URL + 'customer/updateCustomerReport';
const UPDATE_PAYMENT_MADE_REPORT = BASE_URL + 'customer/updatePaymentMadeReport';
const SETTLE_PAYMENT = BASE_URL + 'customer/settlePaymentReport';
const REMOVE_CUSTOMER_REPORT = BASE_URL + 'customer/removeCustomerReport';
const DELETE_CUSTOMER = BASE_URL + 'customer/delete';
const GET_REPAYMENT_HISTORY = BASE_URL + 'repaymentHistory/fetch/';

/// Endpoints regarding creditors
const ADD_CREDITOR = BASE_URL + 'creditor/create';
const ADD_CREDIT = BASE_URL + 'creditor/addCredit';
const UPDATE_CREDITOR = BASE_URL + 'creditor/updateCreditor';
const GET_ALL_CREDITORS_PAGINATED = BASE_URL + 'creditor/fetchAll';
const GET_ALL_CREDITORS = BASE_URL + 'creditor/getAll';
const REMOVE_CREDITS = BASE_URL + 'creditor/deleteCredit';
const DELETE_CREDITOR = BASE_URL + 'creditor/delete';

/// Endpoints regarding store
const GET_STORE_DETAIL = BASE_URL + 'store/fetchDetails';
const GET_STORE_CHARTS_DETAIL = BASE_URL + 'store/fetchDetailsChart';