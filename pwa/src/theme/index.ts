import { extendTheme } from '@chakra-ui/react';

const colors = {
  brand: {
    primary: '#4FA89B',
    secondary: '#4f89a8',
    complement: '#a84f5c',
    100: '#f7fafc',
    900: '#1a365d',
    800: '#008AFC',
    700: '#2a69ac',
    red: '#FF4040',
    blue: '#008AFC',
    one: 'rgb(147,150,251)',
    blueDark: '#0d0889',
    brown: 'rgba(168, 103, 43, 0.65)',
    green: '#CEFFB7',
    beige: '#F5F5DC',
    gold: '#FCC201',
    yellow: '#FFB62E',
    orange: '#FFB62E',
    greenTool: '#BAEF73',
    discord: '#5865F2',
  },

  gradient: {
    basic: 'linear(to-l, brand.primary, brand.complement)',
    green: 'linear-gradient(53deg, rgba(200, 237, 10, 1) 35%, rgba(253, 217, 13, 1) 100%)',
    primary: 'linear-gradient(53deg, #4FA89B 35%, #4f89a8 100%)',
  },
  green: {
    primary: '#baef73',
    one: '#baef73',
  },
  purple: {
    primary: 'rgb(147,150,251)',
    secondary: 'rgb(98 102 225)',
    analogous: '#4e0889',
  },
  blue: {
    primary: '#0d0889',
    secondary: '#084389',
    flash: '##120bb9',
  },
  button: {
    primary: 'rgba(168, 103, 43, 0.65)',
  },

  gray: {
    700: '#252627',
    basic: '#3c3c3c',
    one: '#F5F5F5',
    two: '#EEEEEE',
  },
  body: {
    body: {
      fontFamily: 'monospace',
      bg: '#153e75',
    },
  },
};

const config = {
  initialColorMode: 'light',
  useSystemColorMode: true,
};

const styles = {
  global: (props: any) => ({
    body: {
      bg: props.colorMode === 'dark' ? 'gray.900' : 'gray.50',
      color: props.colorMode === 'dark' ? 'gray.200' : 'gray.800',
      fontFamily: 'monospace',
    },
  }),
};

const components = {
  Button: {
    baseStyle: {
      fontWeight: 'bold',
      borderRadius: 'md',
    },
    variants: {
      solid: (props: any) => ({
        bg: props.colorMode === 'dark' ? 'brand.primary' : 'brand.primary',
        color: 'white',
        _hover: {
          bg: props.colorMode === 'dark' ? 'brand.secondary' : 'brand.secondary',
        },
      }),
    },
  },
};

const theme = extendTheme({
  colors,
  config,
  styles,
  components,
});

export default theme;
