import React from "react";
import Head from "next/head";
import ReviewList from "../../components/review/review-list";
export default function PollPage() {
  return (
    <>
      <Head>
        <title>AFK - Anonymous messages from people around the world and in your country</title>
        <meta name="description" content="AFK is a platform for anonymous messages from people around the world and in your country" />
      </Head>

      <div className="home-page">
        <ReviewList isInternal={true} showMessageForm={true} />
      </div>
    </>
  );
}
