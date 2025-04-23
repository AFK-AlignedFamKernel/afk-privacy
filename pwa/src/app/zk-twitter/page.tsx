"use client"
import { signIn, signOut, useSession } from 'next-auth/react';
import axios from 'axios';
import { Box, Button, Text } from '@chakra-ui/react';
import { useState } from 'react';
export default function ZKPage() {
  const { data: session } = useSession();


  const [zkJWT, setZKJWT] = useState<string | null>(null);
  const [proof, setProof] = useState<string | null>(null);
  const getZKJWT = async () => {
    const res = await axios.get('/api/zk-jwt');
    setZKJWT(res.data.jwt);
  };

  const handleGenerateProof = async () => {
    const res = await axios.post('/api/prove', {
      jwt: zkJWT,
    });
    setProof(res.data.proof);
  };

  return (
    <Box>
      {!session ? (
        <Button onClick={() => signIn('twitter')}>Sign in with Twitter</Button>
      ) : (
        <>
          <Text>Signed in as: {session.user?.name}</Text>
          <Text>Email: {session.user?.email}</Text>
          <Button colorScheme='blue' onClick={getZKJWT}>Get ZK JWT</Button>
          <Button colorScheme='red' onClick={() => signOut()}>Sign out</Button>
        </>
      )}


      <Box>
        <Text>ZK JWT: {zkJWT}</Text>
        <Text>Proof: {proof}</Text>
        <Button colorScheme='green' onClick={handleGenerateProof}>Generate Proof</Button>
      </Box>
    </Box>
  );
}
