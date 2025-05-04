import {createStore} from 'zustand';

import createBoundedUseStore from './createBoundedUseStore';

type State = {
  isLoading: boolean;     
  isLoggedIn: boolean;
  isFetchedDataInitialized: boolean;
};

type Action = {
  setIsLoading: (isLoading: boolean) => void;
  setIsLoggedIn: (isLoggedIn: boolean) => void;
  setIsFetchedDataInitialized: (isFetchedDataInitialized: boolean) => void;
};

export const appStore = createStore<State & Action>((set, get) => ({
  // publicKey and privateKey are set to undefined but we know they are strings
  // so we can cast them as strings without hassle in the app
  isLoading: false,
  isLoggedIn: false,
  isFetchedDataInitialized: false,
  setIsLoading: (isLoading: boolean) => set({isLoading}),
  setIsLoggedIn: (isLoggedIn: boolean) => set({isLoggedIn}),
  setIsFetchedDataInitialized: (isFetchedDataInitialized: boolean) => set({isFetchedDataInitialized}),
}));

export const useAppStore = createBoundedUseStore(appStore);
