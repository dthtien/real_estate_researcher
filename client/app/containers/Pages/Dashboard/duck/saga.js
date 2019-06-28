/* eslint-disable quotes */
import { call, put, takeLatest } from "redux-saga/effects";
import { AddressesApi } from "app-api/controllers";
import { GET_ADDRESSES } from "./constants";
import { indexSuccess, indexError } from './actions';

function* getAddresses(action) {
  const api = new AddressesApi();

  try {
    const data = yield call(api.index, action.payload);
    yield put(indexSuccess(data))
  } catch (error) {
    yield put(indexError(error))
  }
}
export default function* getAddressesSaga() {
  yield takeLatest(GET_ADDRESSES, getAddresses);
}
