import { GoogleOAuthProvider } from "./google-oauth";
import { AnonGroupProvider } from "../types";
import { MicrosoftOAuthProvider } from "./microsoft-oauth";
import { SelfXyzProvider } from "./self-xyz";
// import { SlackOAuthProvider } from "./slack-oauth";

export const Providers: Record<string, AnonGroupProvider> = {
  "google-oauth": GoogleOAuthProvider,
  "microsoft-oauth": MicrosoftOAuthProvider,
  "self-xyz": SelfXyzProvider,
  // "slack-oauth": SlackOAuthProvider,
};

export const ProviderSlugKeyMap: Record<string, AnonGroupProvider> = {
  domain: GoogleOAuthProvider,
};
