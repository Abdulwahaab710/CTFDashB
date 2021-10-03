import * as React from 'react';
import { ChakraProvider, extendTheme } from "@chakra-ui/react";
import { ApolloProvider } from "@apollo/client";

import { client } from './ApolloClient';
import { Routes } from './Routes';

const App = () => {
  const themeConfig = {
    initialColorMode: 'dark',
    useSystemColorMode: false
  }


  const theme = extendTheme({ themeConfig })

  return (
    <ApolloProvider client={client}>
     <ChakraProvider theme={theme}>
      <Routes />
     </ChakraProvider>
    </ApolloProvider>
  )
}

export default App;
