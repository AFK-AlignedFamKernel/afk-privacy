import React from "react";
import Head from "next/head";
import MessageListCountry from "../../components/country/coutry-message-list";

export default function CountryPage() {
  return (
    <>
      <Head>
        <title>StealthNote - Anonymous messages from your coworkers</title>
      </Head>

      <div className="home-page">
        <MessageListCountry showMessageForm />
      </div>
    </>
  );
}
