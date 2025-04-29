"use client";

import React from "react";
import Head from "next/head";
import Image from "next/image";
import { useRouter } from "next/router";
import { useLocalStorage } from "@uidotdev/usehooks";
import MessageList from "../../../components/message-list";
import { ProviderSlugKeyMap } from "../../../lib/providers";
import MessageListCountry from "@/components/country/coutry-message-list";
import COUNTRY_DATA from "@/assets/country";

// See messages from one anon group
export default function NationalityPageInternal() {
  const [currentGroupId] = useLocalStorage<string | null>(
    "currentGroupId",
    null
  );

  const nationality = useRouter().query.nationality as string;
  console.log("nationality", nationality);

  if (!nationality) {
    return null;
  }


  return (
    <>
      <Head>
        <title>{nationality} Anonymous messages from members of {nationality} - AFK</title>
      </Head>

      <div className="domain-page">
        <div className="company-info">
          <div className="company-logo">
            {COUNTRY_DATA[nationality]?.flag}
    
          </div>
          <div>
            <div className="company-title">{COUNTRY_DATA[nationality]?.name}</div>
            <div className="company-description">
              Anonymous messages from members of {COUNTRY_DATA[nationality]?.name}
            </div>
          </div>
        </div>

        <MessageListCountry
          groupId={nationality}
          showMessageForm={true}
          isInternal={true}
        />
      </div>
    </>
  );
}
