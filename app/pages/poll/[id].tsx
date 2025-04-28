"use client";

import React, { useEffect, useState } from "react";
import Head from "next/head";
import Image from "next/image";
import { useRouter } from "next/router";
import { useLocalStorage } from "@uidotdev/usehooks";
import MessageList from "../../components/message-list";
import { ProviderSlugKeyMap } from "../../lib/providers";
import MessageListCountry from "@/components/country/coutry-message-list";
import COUNTRY_DATA from "@/assets/country";
import PollCard from "@/components/review/poll-card";
import { Review } from "@/lib/types";
import Loading from "@/components/small/loading";
export default function PollPage() {
  const [currentGroupId] = useLocalStorage<string | null>(
    "currentGroupId",
    null
  );

  const nationality = useRouter().query.nationality as string;

  const pollId = useRouter().query.id as string;

  const [isLoading, setIsLoading] = useState(false);
  const [isFetched, setIsFetched] = useState(false);


  const [review, setReview] = useState<Review | undefined>(undefined);
  useEffect(() => {
    const fetchReview = async () => {
      try {
        setIsLoading(true)
        const review = await fetch(`/api/poll/fetchPoll?pollId=${pollId}`);
        const reviewData = await review.json();
        console.log(reviewData);
        setReview(reviewData);
        setIsLoading(false);
        setIsFetched(true);
      } catch (error) {

        console.log("error", error)
      } finally {
        setIsLoading(false);
      }

    }
    if (!isFetched && !isLoading && pollId) {
      fetchReview();
      setIsFetched(true);
    }
  }, [isFetched, isLoading, pollId]);

  if (!pollId) {
    return null;
  }



  return (
    <>
      <Head>
        <title>{nationality} Anonymous messages from members of {nationality} - AFK</title>
      </Head>


      {isLoading && <div>Loading...

        <Loading />
      </div>}


      {review &&
        <PollCard review={review} isInternal={currentGroupId == nationality} />

      }

    </>
  );
}
