import { fromJS, List } from 'immutable';
import MenuContent from 'app-api/ui/menu';
import {
  TOGGLE_SIDEBAR,
  OPEN_SUBMENU,
  CLOSE_ALL_SUBMENU,
  CHANGE_THEME,
  CHANGE_MODE,
  CHANGE_GRADIENT,
  CHANGE_DECO,
  CHANGE_BG_POSITION,
  CHANGE_LAYOUT,
  LOAD_PAGE
} from '../../actions/actionConstants';

const initialState = {
  /* Settings for Themes and layout */
  theme: 'blueCyanTheme',
  type: 'light', // light or dark
  gradient: true, // true or false
  decoration: true, // true or false
  bgPosition: 'half', // half, header, full
  layout: 'right-sidebar', // left-sidebar, right-sidebar, top-navigation, mega-menu
  /* End settings */
  sidebarOpen: true,
  pageLoaded: false,
  palette: List([
    { name: 'Fruit', value: 'greenOrangeTheme' },
    { name: 'Purple', value: 'purpleRedTheme' },
    { name: 'Ocean Sky', value: 'skyBlueTheme' },
    { name: 'Rose Gold', value: 'magentaTheme' },
    { name: 'Ultra Violet', value: 'purpleTheme' },
    { name: 'Botani', value: 'pinkGreenTheme' },
    { name: 'Ubuntu', value: 'orangeTheme' },
    { name: 'Patriot', value: 'brownTheme' },
    { name: 'Vintage', value: 'yellowCyanTheme' },
    { name: 'Mint', value: 'blueCyanTheme' },
    { name: 'Deep Ocean', value: 'blueTheme' },
    { name: 'School', value: 'yellowBlueTheme' },
    { name: 'Leaf', value: 'cyanTheme' },
    { name: 'Metal Red', value: 'redTheme' },
    { name: 'Grey', value: 'greyTheme' },
  ]),
  subMenuOpen: []
};

const getMenus = menuArray => menuArray.map(item => {
  if (item.child) {
    return item.child;
  }
  return false;
});

const setNavCollapse = (arr, curRoute) => {
  let headMenu = 'not found';
  for (let i = 0; i < arr.length; i += 1) {
    for (let j = 0; j < arr[i].length; j += 1) {
      if (arr[i][j].link === curRoute) {
        headMenu = MenuContent[i].key;
      }
    }
  }
  return headMenu;
};

const initialImmutableState = fromJS(initialState);

export default function reducer(state = initialImmutableState, action = {}) {
  switch (action.type) {
    case TOGGLE_SIDEBAR:
      return state.withMutations((mutableState) => {
        mutableState.set('sidebarOpen', !state.get('sidebarOpen'));
      });
    case OPEN_SUBMENU:
      return state.withMutations((mutableState) => {
        // Set initial open parent menu
        const activeParent = setNavCollapse(
          getMenus(MenuContent),
          action.initialLocation
        );

        // Once page loaded will expand the parent menu
        if (action.initialLocation) {
          mutableState.set('subMenuOpen', List([activeParent]));
          return;
        }

        // Expand / Collapse parent menu
        const menuList = state.get('subMenuOpen');
        if (menuList.indexOf(action.key) > -1) {
          if (action.keyParent) {
            mutableState.set('subMenuOpen', List([action.keyParent]));
          } else {
            mutableState.set('subMenuOpen', List([]));
          }
        } else {
          mutableState.set('subMenuOpen', List([action.key, action.keyParent]));
        }
      });
    case CLOSE_ALL_SUBMENU:
      return state.withMutations((mutableState) => {
        mutableState.set('subMenuOpen', List([]));
      });
    case CHANGE_THEME:
      return state.withMutations((mutableState) => {
        mutableState.set('theme', action.theme);
      });
    case CHANGE_MODE:
      return state.withMutations((mutableState) => {
        mutableState.set('type', action.mode);
      });
    case CHANGE_GRADIENT:
      return state.withMutations((mutableState) => {
        mutableState.set('gradient', action.gradient);
      });
    case CHANGE_DECO:
      return state.withMutations((mutableState) => {
        mutableState.set('decoration', action.deco);
      });
    case CHANGE_BG_POSITION:
      return state.withMutations((mutableState) => {
        mutableState.set('bgPosition', action.position);
      });
    case CHANGE_LAYOUT:
      return state.withMutations((mutableState) => {
        mutableState.set('layout', action.layout);
      });
    case LOAD_PAGE:
      return state.withMutations((mutableState) => {
        mutableState.set('pageLoaded', action.isLoaded);
      });
    default:
      return state;
  }
}
