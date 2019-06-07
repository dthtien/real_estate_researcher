/* eslint-disable quotes */
import * as types from "./constants";

export const index = (params = {}) => ({
  type: types.GET_ADDRESSES,
  payload: params
});

export const indexSuccess = (data) => ({
  type: types.GET_ADDRESSES_SUCCESS,
  payload: data
})

export const indexError = (error) => ({
  type: types.GET_ADDRESSES_ERROR,
  payload: error
})

export const create = () => { };
