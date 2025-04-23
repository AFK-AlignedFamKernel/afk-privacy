import NextAuth from "next-auth"
import GitHub from "next-auth/providers/github"
import Google from "next-auth/providers/google"
import Twitter from "next-auth/providers/twitter"
import type { Provider } from "next-auth/providers"
 
const providers: Provider[] = [
  Google,
  GitHub,
]
 
export const providerMap = providers
  .map((provider) => {
    if (typeof provider === "function") {
      const providerData = provider()
      return { id: providerData.id, name: providerData.name }
    } else {
      return { id: provider.id, name: provider.name }
    }
  })
  .filter((provider) => provider.id !== "credentials")
 
export const { handlers, auth, signIn, signOut } = NextAuth({
  providers,
  pages: {
    signIn: "/signin",
  },
}) 
// import NextAuth from "next-auth"
// import Google from "next-auth/providers/google"
 
// export const { handlers, signIn, signOut, auth } = NextAuth({
//   providers: [Google],
// })
// // export const { handlers, signIn, signOut, auth } = NextAuth({
// //   providers: [],
// // })