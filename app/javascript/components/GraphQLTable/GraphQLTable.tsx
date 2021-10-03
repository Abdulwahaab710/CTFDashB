import * as React from 'react';
import {
  Box,
  Table,
  Thead,
  Tbody,
  Tr,
  Th,
  Td,
} from "@chakra-ui/react"
import { get } from 'lodash';
import { CursorPagination } from '../CursorPagination/CursorPagination';

// interface TableColumn {
//   title: string,
//   dataIndex: string,
//   key: string,
//   render: (name: string, record: any) => React.ReactNode | string
// }

// interface GraphQLTableProps {
//   dataSource: React.ReactNode,
//   columns: TableColumn[],
//   pageInfo?: React.ReactNode,
//   numOfRows?: number,
//   fetchMore?: React.ReactNode
// }

interface GraphQLTableProps {
  dataSource: any,
  columns: any,
  pageInfo?: any,
  numOfRows?: any,
  fetchMore?: any,
}
export const GraphQLTable: React.FunctionComponent<GraphQLTableProps> = ({ dataSource, columns, pageInfo, numOfRows, fetchMore }) => {

  const fetchCellData = (row: any, dataIndex: string | Array<string | number>) => {
      return get(row, dataIndex);
  };

  const renderCell = (column: any, row: any) => {
    if (column.render) {
      return column.render(fetchCellData(row, column.dataIndex), row)
    } else {
      debugger
      return fetchCellData(row, column.dataIndex)
    }
  }

  const TablePagination = () => {
    if (pageInfo) {
      return (
        <Box p={2}>
          <CursorPagination
            pageInfo={pageInfo}
            numOfRows={numOfRows}
            fetchMore={fetchMore}
          />
        </Box>
      )
    } else {
      return null
    }
  }

  return (
    <Box borderWidth="1px" borderRadius="lg" p={1}>
      <Table variant="striped" colorScheme="gray">
        <Thead>
          <Tr>
            {
              columns.map((column) => {
                return (
                  <Th key={column.key}>{column.title}</Th>
                )
              })
            }
          </Tr>
        </Thead>
        <Tbody>
          {
            dataSource.map((row) => {
              return (
                <Tr key={row.id}>
                  {
                    columns.map((column) => {
                      return (
                        <Td>{renderCell(column, row)}</Td>
                      )
                    })
                  }
                </Tr>
              )
            })
          }
        </Tbody>
      </Table>
      <TablePagination />
    </Box>
  )
}
