import * as React from 'react';
import { Box } from '@chakra-ui/react';

export const Form = (props) => {
  return (
    <Box as="form" onSubmit={props.onSubmit} {...props}>
      {props.children}
    </Box>
  );
}
