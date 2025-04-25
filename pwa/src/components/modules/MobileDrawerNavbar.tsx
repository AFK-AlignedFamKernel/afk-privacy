// components/MobileDrawerNavbar.tsx
import {HamburgerIcon} from '@chakra-ui/icons';
import {
  Box,
  Button,
  Drawer,
  DrawerBody,
  DrawerCloseButton,
  DrawerContent,
  DrawerOverlay,
  IconButton,
  useColorModeValue,
  useDisclosure,
  VStack,
} from '@chakra-ui/react';
import Link from 'next/link';
import {useRef} from 'react';

import ColorModeToggle from '../button/ColorToggleMode';
import MenuNav from './MenuNav';

const MobileDrawerNavbar: React.FC = () => {
  const {isOpen, onOpen, onClose} = useDisclosure();
  const btnRef = useRef<HTMLButtonElement>(null);
  const bgColor = useColorModeValue('gray.300', 'gray.700');
  const textColor = useColorModeValue('gray.800', 'gray.300');
  return (
    <Box p={4} boxShadow="md" as="nav" bg={bgColor} color={textColor}>
      {/* <HStack justifyContent="space-between" alignItems="center"> */}
      <IconButton
        ref={btnRef}
        icon={<HamburgerIcon />}
        // style={{
        // }}
        aria-label="Open menu"
        // variant="outline"
        onClick={onOpen}
      />
      {/* </HStack> */}

      {/* Drawer */}
      <Drawer isOpen={isOpen} placement="left" onClose={onClose} finalFocusRef={btnRef}>
        <DrawerOverlay />
        <DrawerContent>
          <DrawerCloseButton />
          <DrawerBody>
            <VStack align="start" spacing={4} mt={8}>
              {/* Navigation Links */}
              <MenuNav></MenuNav>

              <Link href="/" passHref>
                <Button variant="ghost" width="100%" onClick={onClose}>
                  Home
                </Button>
              </Link>
              <Link href="/zk-email" passHref>
                <Button variant="ghost" width="100%" onClick={onClose}>
                  Zk Email
                </Button>
              </Link>
          
              <Link href="/zk-twitter" passHref>
                <Button variant="ghost" width="100%" onClick={onClose}>
                  Zk Twitter
                </Button>
              </Link>
              <Link href="/z-did" passHref>
                <Button variant="ghost" width="100%" onClick={onClose}>
                  Zk DID
                </Button>
              </Link>
              <Link href="/zkdid" passHref>
                <Button variant="ghost" width="100%" onClick={onClose}>
                  Zk DID
                </Button>
              </Link>
               <Link href="/sign-in" passHref>
                <Button variant="ghost" width="100%" onClick={onClose}>
                  Sign In
                </Button>
              </Link>
              {/* <Link href="/gift" passHref>
                <Button variant="ghost" width="100%" onClick={onClose}>
                  Gift
                </Button>
              </Link> */}
              <ColorModeToggle></ColorModeToggle>
            </VStack>
          </DrawerBody>
        </DrawerContent>
      </Drawer>
    </Box>
  );
};

export default MobileDrawerNavbar;
