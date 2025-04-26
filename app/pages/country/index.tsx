import React from "react";
import Head from "next/head";
import MessageListCountry from "../../components/country/coutry-message-list";

export default function CountryPage() {
  return (
    <>
      <Head>
        <title>AFK - Anonymous messages from people around the world and in your country</title>
        <meta name="description" content="AFK is a platform for anonymous messages from people around the world and in your country" />
      </Head>

      <div className="home-page">
        <MessageListCountry showMessageForm />
      </div>
    </>
  );
}
