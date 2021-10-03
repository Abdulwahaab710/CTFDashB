import * as React from 'react';
import { IconButton, Select, HStack, Flex } from "@chakra-ui/react"
import { AiOutlineArrowLeft, AiOutlineArrowRight, AiOutlineDown } from "react-icons/ai";

const { useState } = React;

const CursorPagination = ({ pageInfo, fetchMore, numOfRows }) => {
  const [numberOfRows, setNumberOfRows] = useState(numOfRows);
  const [loadingPrev, setLoadingPrev] = useState(false);
  const [loadingNext, setLoadingNext] = useState(false);
  const handleMenuClick = (e: any) => {
    setNumberOfRows(parseInt(e.target.value));
  }

  const menu = (
    <Select icon={<AiOutlineDown/>} onChange={handleMenuClick}>
      {[10, 20, 50, 100].map((pageSize) => {
        return <option key={pageSize} value={pageSize}>{pageSize} / pages</option>
      })}
    </Select>
  )

  const fetchNext = () => {
    const { endCursor } = pageInfo;
    fetchMore({
      variables: { first: numberOfRows, last: undefined, after: endCursor },
      updateQuery: (_prevResult, { fetchMoreResult }) => { return fetchMoreResult; }
    });
    setLoadingNext(true);
  }

  const fetchPrev = () => {
    const { startCursor } = pageInfo;
    fetchMore({
      variables: { first: undefined, last: numberOfRows, before: startCursor  },
      updateQuery: (_prevResult, { fetchMoreResult }) => { return fetchMoreResult; }
    });
    setLoadingPrev(true);
  }

  if (!(pageInfo.hasPreviousPage || pageInfo.hasNextPage)) {
    return <></>
  }

  return (
    <Flex justifyContent="center">
      <HStack>
        <IconButton
          aria-label="Previous Page"
          colorScheme="blue"
          icon={<AiOutlineArrowLeft />}
          onClick={fetchPrev}
          isDisabled={!pageInfo.hasPreviousPage}
          isLoading={loadingPrev}
        />
        {menu}
        <IconButton
          aria-label="Next Page"
          colorScheme="blue"
          icon={<AiOutlineArrowRight />}
          onClick={fetchNext}
          isDisabled={!pageInfo.hasNextPage}
          isLoading={loadingNext}
        />
      </HStack>
    </Flex>
  )
}

export { CursorPagination };
