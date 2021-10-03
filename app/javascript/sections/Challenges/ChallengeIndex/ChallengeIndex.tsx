import * as React from 'react';
import { useQuery, useMutation } from '@apollo/client';
import { Link, useHistory } from 'react-router-dom';
import {
  Avatar,
  Button,
  Box,
  Menu,
  MenuList,
  MenuItem,
  FormControl,
  FormErrorMessage,
  FormLabel,
  Input,
  InputGroup,
  InputLeftAddon,
  InputRightElement,
  Modal,
  ModalBody,
  ModalCloseButton,
  ModalContent,
  ModalFooter,
  ModalHeader,
  ModalOverlay,
  MenuButton,
  IconButton,
  useToast,
} from "@chakra-ui/react"
import { FaEllipsisV } from "react-icons/fa";
import { FiEdit } from "react-icons/fi";
import { BiDuplicate } from "react-icons/bi";
import { RiDeleteBin5Line } from "react-icons/ri";


import { GraphQLTable } from '../../../components/GraphQLTable/GraphQLTable'
import { PageHeader } from '../../../components/PageHeader'
import { TableLayoutSkeleton } from '../../../components/Skeleton/TableLayoutSkeleton';

import ChallengesQuery from '../graphql/challenges_query.graphql';
import UpdateChallengeMutation from '../graphql/update_challenge_mutation.graphql'

const { useState } = React;


const ChallengeStatusButton = ({id, status}: { id: number, status: boolean }): JSX.Element => {
  const [updateChallenge] = useMutation(UpdateChallengeMutation);
  const [isLoading, setIsloading] = useState(false)
  const [challengeStatus, setChallengeStatus] = useState(status);
  const toast = useToast();

  const onClick = () => {
    setIsloading(true)
    updateChallenge({ variables: { id: id, active: !status } }).then(({ data }) => {
      setChallengeStatus(data.updateChallenge.active);
      toast({
        title: "Successfully updated the challenge",
        status: "success",
        duration: 9000,
        isClosable: true,
      });
      setIsloading(false);
    }).catch(() => {
      toast({
        title: "Something went wrong!",
        description: "Failed to update the challenge",
        status: "error",
        duration: 9000,
        isClosable: true,
      });
      setIsloading(false);
    });
  }

  return (
    <Button
      onClick={onClick}
      isLoading={isLoading}
    >
      { challengeStatus ? 'Deactivate' : 'Activate' }
    </Button>
  )
}

const ChallengeDropDown = ({id}: { id: number }): JSX.Element => {

  const history = useHistory();
  const editOnClick = () => history.push(`/admin/challenges/${id}/edit`);

  return (
    <Menu>
      <MenuButton
        as={IconButton}
        aria-label="Options"
        icon={<FaEllipsisV />}
        variant="outline"
      />
      <MenuList>
        <MenuItem icon={<FiEdit />} onClick={editOnClick}>
          Edit
        </MenuItem>
        <MenuItem icon={<BiDuplicate />}>
          Duplicate
        </MenuItem>
        <MenuItem icon={<RiDeleteBin5Line />}>
          Delete
        </MenuItem>
      </MenuList>
    </Menu>
  )
}

const Form = (props: any) => {
  return (
    <Box as="form" onSubmit={props.onSubmit} {...props}>
      {props.children}
    </Box>
  )
}

const ChallengeIndex = () => {
  const numOfRows = 10;
  const { loading, error, data, fetchMore } = useQuery(ChallengesQuery, { variables: { first: numOfRows }});

  const columns = [
    {
      title: 'Title',
      dataIndex: 'title',
      key: 'title',
      render: (name: string, record: any) => <Link to={`/admin/challenges/${record.id}`}>{name}</Link>
    },
    {
      title: 'Category',
      dataIndex: ['category', 'name'],
      key: ['category', 'name'],
      render: (name: string, record: any) => <Link to={`/admin/category/${record.category.id}`}>{name}</Link>
    },
    {
      title: 'Author',
      dataIndex: ['user', 'name'],
      key: ['user', 'name'],
      render: (name: string, record: any) => <Avatar name={name} src={record.user.gravatarUrl} />
    },
    {
      title: '',
      dataIndex: 'active',
      key: 'active',
      render: (name: boolean, record: any) => <ChallengeStatusButton status={name} id={record.id} />
    },
    {
      title: '',
      dataIndex: 'id',
      key: 'id',
      render: (id: number) => <ChallengeDropDown id={id} />
    },
  ];

  if (loading) return <TableLayoutSkeleton numberOfRows={numOfRows} numberOfColumns={columns.length} />

  if (error) return <TableLayoutSkeleton numberOfRows={numOfRows} numberOfColumns={columns.length} />

  return (
    <>
      <PageHeader title="Challenges" extra={<Button colorScheme="blue">Add new challenge</Button>} />
      <GraphQLTable
        dataSource={data.challenges.nodes}
        columns={columns}
        pageInfo={data.challenges.pageInfo}
        numOfRows={numOfRows}
        fetchMore={fetchMore}
      />
    </>
  )
}

export default ChallengeIndex;
