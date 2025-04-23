import { NextRequest, NextResponse } from 'next/server';
import { getToken } from 'next-auth/jwt';
import { SignJWT } from 'jose';
import { generateKeyPair } from 'jose';

export async function GET(req: NextRequest) {
  try {
    const token = await getToken({ req, secret: process.env.NEXTAUTH_SECRET });
    
    if (!token) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
    }

    const { privateKey, publicKey } = await generateKeyPair('RS256');

    const payload = {
      email: token.email,
      twitter_id: token.twitter_id,
    };

    const zkJwt = await new SignJWT(payload)
      .setProtectedHeader({ alg: 'RS256' })
      .sign(privateKey);

    return NextResponse.json({ jwt: zkJwt });
  } catch (error) {
    console.error('Error generating ZK JWT:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
}
