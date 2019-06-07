import * as types from './constants';
import { fromJS } from 'immutable';

export const initialState = fromJS({
  addresses: {
    loading: false,
    data: null,
    error: false
  }
})

// const initialImmutableState = fromJS(initialState);

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case types.GET_ADDRESSES:
      return state.withMutations((mutableState) => {
        mutableState.set('addresses', fromJS({
          data: null,
          loading: true,
          error: false
        }));
      })
    case types.GET_ADDRESSES_SUCCESS:
      return state.withMutations((mutableState) => {
        mutableState.set('addresses', fromJS({
          data: action.payload,
          loading: false,
          error: false
        }));
      })
    case types.GET_ADDRESSES_ERROR:
      return state.withMutations((mutableState) => {
        mutableState.set('addresses', fromJS({
          data: null,
          loading: true,
          error: false
        }));
      })
    default:
      return state
  }
}