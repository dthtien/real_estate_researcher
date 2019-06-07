import { createSelector } from 'reselect';
import { initialState } from './reducer';

// const selectHome = state => state. || initialState;

export const addressesSelector = () =>
  createSelector(
    state => state.get('dashboard', initialState) || initialState,
    state => state.get('addresses').toJS()
  )