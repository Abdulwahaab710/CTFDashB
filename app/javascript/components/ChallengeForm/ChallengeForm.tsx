import * as React from 'react';
import { useQuery } from '@apollo/client';
import {
  Button,
  FormControl,
  FormLabel,
  Input,
  Switch,
  Select,
  Skeleton,
  useDisclosure,
  Modal,
  ModalOverlay,
  ModalContent,
  ModalHeader,
  ModalFooter,
  ModalBody,
  ModalCloseButton,
} from "@chakra-ui/react"

import { Form } from '../Form';

import CategoriesQuery from './CategoriesQuery.graphql';

interface ChallengeFormProps {
  title?: string,
  categoryId?: number,
  description?: string,
  flag?: string,
  points?: string,
  maxTries?: string,
  message?: string,
  active?: boolean,
  // onSubmit:
}

const CategoryModal = ({ setCategoryId, isOpen, onOpen, onClose }) => {
  const handleChange = () => {};
  return (
    <Modal isOpen={isOpen} onClose={onClose}>
      <ModalOverlay />
      <ModalContent>
        <ModalHeader>Create Category</ModalHeader>
        <ModalCloseButton />
        <ModalBody>
          <Form onSubmit={() => {}}>
            <FormControl id='title' isRequired>
              <FormLabel>Challenge title</FormLabel>
              <Input
                placeholder="Challenge title"
                onChange={handleChange}
                name='title'
                isRequired
              />
            </FormControl>
          </Form>
        </ModalBody>

        <ModalFooter>
          <Button colorScheme="blue" mr={3} onClick={onClose}>
            Add Category
          </Button>
        </ModalFooter>
      </ModalContent>
    </Modal>
  )
}

const CategorySelect = ({ categoryId }) => {
  const { loading, data } = useQuery(CategoriesQuery);
  if (loading) return <Skeleton height="40px" />

  return (
    <Select placeholder="Category">
      {data.categories.nodes.map(category => <option value={category.id} selected={categoryId == category.id}>{category.name}</option>)}
    </Select>
  )
}

export const ChallengeForm = ({ title, categoryId, description, flag, points, maxTries, message, active, onSubmit}: ChallengeFormProps) => {
  const handleChange = () => {
  }

  const { isOpen, onOpen, onClose } = useDisclosure()

  return (
    <Form onSubmit={onSubmit}>
      <FormControl id='title' isRequired>
        <FormLabel>Challenge title</FormLabel>
        <Input
          placeholder="Challenge title"
          onChange={handleChange}
          name='title'
          value={title}
          isRequired
        />
      </FormControl>

      <FormControl id='category' isRequired>
        <FormLabel>Category</FormLabel>
        <CategorySelect categoryId={categoryId} />
        <Button
          mt={4}
          colorScheme="blue"
          onClick={onOpen}
        >
        Add Category
        </Button>
      </FormControl>

      <FormControl id='description' isRequired>
        <FormLabel>Description</FormLabel>
        <Input
          placeholder="description"
          onChange={handleChange}
          name='description'
          value={description}
          isRequired
        />
      </FormControl>

      <FormControl id='title' isRequired>
        <FormLabel>Challenge files</FormLabel>
        <Input
          placeholder="Challenge files"
          onChange={handleChange}
          name='title'
          value={title}
          isRequired
        />
      </FormControl>

      <FormControl id='flag' isRequired>
        <FormLabel>Flag</FormLabel>
        <Input
          placeholder="flag{this is a flag}"
          onChange={handleChange}
          name='flag'
          value={flag}
          isRequired
        />
      </FormControl>

      <FormControl id='points' isRequired>
        <FormLabel>Points</FormLabel>
        <Input
          placeholder="Points"
          onChange={handleChange}
          name='points'
          value={points}
          isRequired
        />
      </FormControl>

      <FormControl id='Max tries' isRequired>
        <FormLabel>Max tries</FormLabel>
        <Input
          placeholder="100"
          onChange={handleChange}
          name='Max tries'
          value={maxTries}
          isRequired
        />
      </FormControl>

      <FormControl id='message' isRequired>
        <FormLabel>Message after the challenge is solved</FormLabel>
        <Input
          onChange={handleChange}
          name='message'
          value={message}
          isRequired
        />
      </FormControl>

      <FormControl id='active' display="flex" alignItems="center" isRequired>
        <FormLabel htmlFor="email-alerts" mb="0">Active</FormLabel>
        <Switch id="email-alerts" defaultChecked={active} />
      </FormControl>

      <Button
        mt={4}
        type="submit"
        colorScheme="blue"
      >
      Add Challenge
      </Button>
      <CategoryModal setCategoryId={''} isOpen={isOpen} onOpen={onOpen} onClose={onClose} />
    </Form>
  )
}
