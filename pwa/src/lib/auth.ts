import NextAuth from 'next-auth';
import TwitterProvider from 'next-auth/providers/twitter';

export const Auth = NextAuth({
  providers: [
    TwitterProvider({
      clientId: process.env.TWITTER_CLIENT_ID!,
      clientSecret: process.env.TWITTER_CLIENT_SECRET!,
      
      // version: '2.0',
    }),
  ],
  callbacks: {
    async jwt({ token, account, profile }) {
      if (account && profile) {
        token.twitter_id = profile.id_str;
        token.email = `${profile.id_str}@twitter.local`; // Twitter doesn’t provide emails in v2
      }
      return token;
    },
    async session({ session, token }) {
      return {
        ...session,
        twitter_id: token.twitter_id,
        email: token.email
      };
    },
  },
  session: {
    strategy: 'jwt',
  },
  secret: process.env.NEXTAUTH_SECRET,
});

const { handlers, auth, signIn, signOut } = Auth;

export { handlers, auth, signIn, signOut };
export default Auth;