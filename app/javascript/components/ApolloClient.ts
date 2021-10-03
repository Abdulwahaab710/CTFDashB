import {
  ApolloClient,
  InMemoryCache,
  createHttpLink,
} from '@apollo/client';;
import { setContext } from '@apollo/client/link/context';

const httpLink = createHttpLink({
  uri: '/admin/graphql',
});

const csrfLink = setContext((_, { headers }) => {
  const csrfToken = document.querySelector('[name=csrf-token]').getAttribute('content');
  return {
    headers: {
      ...headers,
      "X-CSRF-TOKEN": csrfToken
    }
  }
});

export const client = new ApolloClient({
  link: csrfLink.concat(httpLink),
  cache: new InMemoryCache(),
});

