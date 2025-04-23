'use client';

import { Box, Flex, IconButton, useColorMode, useColorModeValue } from '@chakra-ui/react';
import Link from 'next/link';
import React, { useState } from 'react';
import { HamburgerIcon } from '@chakra-ui/icons';

import MenuNav from './MenuNav';
import  MobileDrawerNavbar from './MobileDrawerNavbar';
import { NavigationLinks } from './NavigationLinks';

export function Navbar() {
  const { colorMode, toggleColorMode } = useColorMode();
  const bgColor = useColorModeValue('gray.100', 'gray.900');
  const textColor = useColorModeValue('gray.800', 'gray.200');


  const [isOpen, setIsOpen] = useState(false);


  const handleClick = () => {
    // toggleColorMode();
    setIsOpen(!isOpen);
  };

  return (
    <Box
      as="nav"
      position="sticky"
      top={0}
      zIndex={10}
      bg={bgColor}
      color={textColor}
      boxShadow="sm"
    >
      <Flex
        maxW="1200px"
        mx="auto"
        px={4}
        py={4}
        justify="space-between"
        align="center"
      >
        <Flex align="center" gap={2}>
          <img
            src="/assets/pepe-logo.png"
            alt="AFK logo"
            width="40px"
            height="40px"
          />
          <Link href="/">
            <Box
              as="h5"
              fontSize={{ base: 'lg', md: 'xl' }}
              fontWeight="bold"
              _hover={{ opacity: 0.8 }}
            >
              AFK
            </Box>
          </Link>
        </Flex>

        <Flex
          display={{ base: 'none', md: 'flex' }}
          align="center"
          gap={6}
        >
          <Link href="/about">
            <Box _hover={{ opacity: 0.8 }}>About</Box>
          </Link>
          <Link href="/privacy">
            <Box _hover={{ opacity: 0.8 }}>Privacy</Box>
          </Link>
          <Link href="/contact">
            <Box _hover={{ opacity: 0.8 }}>Contact</Box>
          </Link>
        </Flex>

        <NavigationLinks></NavigationLinks>

        <IconButton
          display={{ base: 'flex', }}
          aria-label="Open menu"
          icon={<HamburgerIcon />}
          variant="ghost"
          onClick={handleClick}
        />


        {isOpen ? (
          <MobileDrawerNavbar></MobileDrawerNavbar>
        ) : null}

      </Flex>
    </Box>
  );
}

export default Navbar;