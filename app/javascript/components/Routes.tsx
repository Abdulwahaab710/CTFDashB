import * as React from 'react';
import { Box } from "@chakra-ui/react";
import { Route, Switch } from 'react-router-dom';
import { useQuery } from "@apollo/client";

import { UserContext } from './UserContext';

const { useState, useEffect } = React;

import Navbar from './Navbar';
import ChallengeNew from '../sections/Challenges/ChallengeNew/ChallengeNew';
import ChallengeIndex from '../sections/Challenges/ChallengeIndex/ChallengeIndex';

import CurrentUserQuery from './graphql/CurrentUserQuery.graphql';

export const Routes = () => {
  const [currentUser, setCurrentUser] = useState({
    name: 'John Doe',
    profilePictureURL: 'https://secure.gravatar.com/avatar/64e1b8d34f425d19e1ee2ea7236d3028?&d=mm'
  });

  const { loading, data } = useQuery(CurrentUserQuery);

  useEffect(() => {
    if (!loading) {
      setCurrentUser(data.currentUser);
    }
  })

  return (
    <UserContext.Provider value={{ currentUser, setCurrentUser }}>
      <Navbar />
      <Box p={4}>
        <Switch>
          <Route path="/admin/new/challenges/new" exact component={ChallengeNew} />
          <Route path="/admin/new/challenges/" exact component={ChallengeIndex} />
        </Switch>
      </Box>
    </UserContext.Provider>
  )
}
