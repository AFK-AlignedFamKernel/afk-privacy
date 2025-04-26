import React from "react";
import Head from "next/head";
import MessageList from "../components/message-list";

export default function HomePage() {
  return (
    <>
      <Head>
        <title>AFK - Anonymous messages from your coworkers, country and people</title>
        <meta name="description" content="AFK is a platform for anonymous messages from your coworkers, country and people" />
      </Head>

      <div className="home-page">
        <MessageList showMessageForm />
      </div>
    </>
  );
}
