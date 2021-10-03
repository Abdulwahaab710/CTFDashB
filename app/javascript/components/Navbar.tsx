import * as React from 'react';
import {
  Avatar,
  Box,
  Button,
  Flex,
  HStack,
  Heading,
  IconButton,
  Link,
  Menu,
  MenuButton,
  MenuDivider,
  MenuItem,
  MenuList,
  Stack,
  useColorMode,
  useColorModeValue,
  useDisclosure,
} from '@chakra-ui/react';
import { ImMenu } from "react-icons/im";
import { Link as RouteLink, useLocation } from 'react-router-dom';
import { RiCloseFill } from "react-icons/ri";
import { BiSun, BiMoon } from "react-icons/bi";

import { UserContext } from './UserContext';

const { useContext } = React;

const Links = [
  { key: 'challenges', text: 'Challenges', path: '/admin/new/challenges' },
  { key: 'categories', text: 'Categories', path: '/admin/new/categories' },
  { key: 'users', text: 'Users', path: '/admin/new/users' },
  { key: 'pages', text: 'Pages', path: '/admin/new/pages' },
  { key: '', text: 'Scoreboard', path: '/scoreboard' },
];

const NavLink = ( {text, path, isActive}: { text: string, path: string, isActive: Boolean }) => (
  <RouteLink to={path}>
    <Link
      px={2}
      py={1}
      rounded={'md'}
      bg={isActive ? useColorModeValue('gray.200', 'gray.700') : undefined}
      _hover={{
        textDecoration: 'none',
        bg: useColorModeValue('gray.200', 'gray.700'),
      }}>
      {text}
    </Link>
  </RouteLink>
);

const toggleThemeIcon = (colorMode: string) => {
  if (colorMode === 'light') {
    return <BiMoon />
  } else {
    return <BiSun />
  }
}

const Navbar = () => {
  const location = useLocation();
  const { currentUser } = useContext(UserContext);
  const { isOpen, onOpen, onClose } = useDisclosure();

  const { colorMode, toggleColorMode } = useColorMode();

  const toggleIcon = toggleThemeIcon(colorMode)

  return (
    <>
      <Box bg={useColorModeValue('gray.100', 'gray.900')} px={4}>
        <Flex h={16} alignItems={'center'} justifyContent={'space-between'}>
          <IconButton
            size={'md'}
            icon={isOpen ? <RiCloseFill /> : <ImMenu />}
            aria-label={'Open Menu'}
            display={{ md: 'none' }}
            onClick={isOpen ? onClose : onOpen}
          />
          <HStack spacing={8} alignItems={'center'}>
            <Box><Heading>CTFDashB</Heading></Box>
            <HStack
              as={'nav'}
              spacing={4}
              display={{ base: 'none', md: 'flex' }}>
              {Links.map((link) => (
                <NavLink {...link} isActive={location.pathname === link.path} />
              ))}
            </HStack>
          </HStack>
          <Flex alignItems={'center'}>
            <Menu>
              <HStack spacing={2}>
                <IconButton
                  size="md"
                  rounded="md"
                  variant="outline"
                  onClick={() => toggleColorMode()}
                  aria-label="Toggle theme"
                  icon={toggleIcon}
                />
                <MenuButton
                  as={Button}
                  rounded={'full'}
                  variant={'link'}
                  cursor={'pointer'}
                  minW={0}>
                  <Avatar
                    size={'sm'}
                    src={currentUser.profilePictureURL}
                  />
                </MenuButton>
                <MenuList>
                  <MenuItem><Link to={`/${currentUser.username}`}>Your profile</Link></MenuItem>
                  <MenuDivider />
                  <MenuItem>CTF Settings</MenuItem>
                  <MenuDivider />
                  <MenuItem>Settings</MenuItem>
                  <MenuItem><Link to='/logout'>Log out</Link></MenuItem>
                </MenuList>
              </HStack>
            </Menu>
          </Flex>
        </Flex>

        {isOpen ? (
          <Box pb={4} display={{ md: 'none' }}>
            <Stack as={'nav'} spacing={4}>
              {Links.map((link) => (
                <NavLink {...link} />
              ))}
            </Stack>
          </Box>
        ) : null}
      </Box>
    </>
  );
}

export default  Navbar;
